import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/keyword.dart';
import 'package:cookpad_app_clone/utils/app_logger.dart';
import 'package:logging/logging.dart';

class KeywordService {
  final CollectionReference _keywordCollection = FirebaseFirestore.instance
      .collection('keywords');
  final Logger _logger = AppLogger.getLogger('KeywordService');

  Future<List<Keyword>> getAllKeywords() async {
    try {
      final snapshot =
          await _keywordCollection
              .orderBy('searchCount', descending: true)
              .get();
      return snapshot.docs.map((doc) => Keyword.fromFirestore(doc)).toList();
    } catch (e, stacktrace) {
      _logger.severe('Lỗi khi lấy danh sách keyword: $e', e, stacktrace);
      rethrow;
    }
  }

  Future<void> addKeyword(Keyword keyword) async {
    final doc = _keywordCollection.doc(keyword.title);
    try {
      final snapshot = await doc.get();

      if (!snapshot.exists) {
        await doc.set(keyword.toMap());
        _logger.info('Đã thêm keyword: ${keyword.title}');
      } else {
        _logger.warning(
          'Keyword "${keyword.title}" đã tồn tại, không thêm lại.',
        );
      }
    } catch (e, stacktrace) {
      _logger.severe(
        'Lỗi khi thêm keyword "${keyword.title}": $e',
        e,
        stacktrace,
      );
      rethrow;
    }
  }

  Future<void> updateKeyword(String id, Keyword keyword) async {
    final doc = _keywordCollection.doc(id);
    try {
      final snapshot = await doc.get();

      if (!snapshot.exists) {
        _logger.warning('Keyword với id "$id" không tồn tại.');
        return;
      }

      await doc.update({
        'title': keyword.title,
        'searchCount': keyword.searchCount,
      });
      _logger.info('Đã cập nhật keyword với id: $id');
    } catch (e, stacktrace) {
      _logger.severe(
        'Lỗi khi cập nhật keyword với id "$id": $e',
        e,
        stacktrace,
      );
      rethrow;
    }
  }

  Future<void> deleteKeyword(String id) async {
    try {
      await _keywordCollection.doc(id).delete();
      _logger.info('Đã xóa keyword với id: $id');
    } catch (e, stacktrace) {
      _logger.severe('Lỗi khi xóa keyword với id "$id": $e', e, stacktrace);
      rethrow;
    }
  }

  Future<void> incrementSearchCount(String title) async {
    final doc = _keywordCollection.doc(title);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(doc);

        if (snapshot.exists && snapshot.data() != null) {
          final currentData = Keyword.fromFirestore(snapshot);
          final count = currentData.searchCount + 1;
          transaction.update(doc, {'searchCount': count});
          _logger.info('Đã tăng searchCount cho keyword: $title lên $count');
        } else {
          final keyword = Keyword(
            id: doc.id,
            title: title,
            image: null,
            searchCount: 1,
          );
          transaction.set(doc, keyword.toMap());
          _logger.info('Tạo mới keyword với title "$title" và searchCount = 1');
        }
      });
    } catch (e, stacktrace) {
      _logger.severe(
        'Lỗi khi tăng searchCount cho keyword "$title": $e',
        e,
        stacktrace,
      );
      rethrow;
    }
  }

  Future<List<Keyword>> getPopularKeywords() async {
    try {
      final snapshot =
          await _keywordCollection
              .orderBy('searchCount', descending: true)
              .limit(8)
              .get();

      final keywords =
          snapshot.docs.map((doc) => Keyword.fromFirestore(doc)).toList();
      _logger.info('Lấy ra 8 từ khóa phổ biến nhất thành công.');
      return keywords;
    } catch (e, stacktrace) {
      _logger.severe('Lỗi khi lấy 8 từ khóa phổ biến nhất: $e', e, stacktrace);
      rethrow;
    }
  }
}
