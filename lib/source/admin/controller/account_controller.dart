import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/model/account_model.dart';
import 'package:pbl3/source/admin/model/tech_model.dart';

class AccountController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  // Lấy thông tin tài khoản từ Firestore
  Future<AccountModel> getAccount(String userId) async {
    try {
      final snapshot = await _userCollection.doc(userId).get();
      if (snapshot.exists) {
        return AccountModel.fromMap(
          snapshot.data() as Map<String, dynamic>,
          userId,
        );
      } else {
        throw Exception('Tài khoản không tồn tại.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cập nhật tài khoản
  Future<void> updateAccount(String userId, AccountModel account) async {
    try {
      await _userCollection.doc(userId).update(account.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Lấy danh sách người dùng dạng Stream
  Stream<List<AccountModel>> getUsersStream() {
    return _userCollection
        .where('role', isEqualTo: 'user')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AccountModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Bật hoặc tắt trạng thái tài khoản
  Future<void> toggleAccountStatus(String userId, String currentStatus) async {
    try {
      final newStatus = currentStatus == 'Active' ? 'Inactive' : 'Active';
      await _userCollection.doc(userId).update({'status': newStatus});
    } catch (e) {
      rethrow;
    }
  }

  // Lấy danh sách kỹ thuật viên dạng Stream
  Stream<List<Technician>> getTechniciansStream() {
    return _userCollection
        .where('role', isEqualTo: 'Tech')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Technician.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  // Cập nhật kỹ thuật viên
  Future<void> updateTechnician(
    Technician technician, {
    required String name,
    required String email,
    required String address,
    required String phone,
    required String expertise,
    required BuildContext context,
  }) async {
    try {
      await _userCollection.doc(technician.id).update({
        'name': name,
        'email': email,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
        'expertise': expertise,
        'phone': phone,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thông tin kỹ thuật viên thành công!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  // Xóa kỹ thuật viên
  Future<void> deleteTechnician(String technicianId) async {
    try {
      await _userCollection.doc(technicianId).delete();
    } catch (e) {
      print('Lỗi khi xóa kỹ thuật viên: $e');
    }
  }

  // Đăng ký kỹ thuật viên
  Future<void> registerTechnician(Technician technician) async {
    try {
      // Tạo tài khoản trên Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: technician.email,
        password: technician.password ?? '',
      );

      // Lưu thông tin vào Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': technician.name,
        'email': technician.email,
        'address': technician.address,
        'phone': technician.phone,
        'expertise': technician.expertise,
        'role': technician.role,
        'status': technician.status,
        'avatar': technician.avatar,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi khi đăng ký kỹ thuật viên: $e');
    }
  }
}
