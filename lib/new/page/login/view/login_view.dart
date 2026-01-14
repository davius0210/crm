import 'package:crm_apps/new/component/customtext_component.dart';
import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:crm_apps/new/page/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.put jika belum di-bind di route, 
    // tapi lebih disarankan menggunakan GetBuilder saja jika controller sudah ada
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold( // Tambahkan Scaffold agar layout lebih stabil
          body: Stack(
            children: [
              // 1. BACKGROUND LAYER
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0F2F1),
                      Color(0xFFE1F5FE),
                      Colors.white,
                    ],
                  ),
                ),
              ),

              // 2. FORM & BUTTON LAYER
              Center( // Menggunakan Center lebih aman daripada Align center di dalam Stack
                child: SingleChildScrollView( // Tambahkan ini agar tidak error saat keyboard muncul
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // --- LAYER BELAKANG: TOMBOL LOGIN ---
                        // Pindahkan Obx seminimal mungkin hanya pada konten yang berubah
                        Padding(
                          padding: const EdgeInsets.only(top: 40), // Beri ruang agar tidak menumpuk
                          child: InkWell(
                            onTap: () {
                              if (!controller.isLoading.value) {
                                controller.fetchLogin(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  ColorHelper.primary,
                                  ColorHelper.secondary,
                                ]),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorHelper.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.only(bottom: 18),
                              child: Obx(() => controller.isLoading.value
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.2,
                                      ),
                                    )),
                            ),
                          ),
                        ),

                        // --- LAYER DEPAN: FORM INPUT ---
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(bottom: 65),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                  image: AssetImage('assets/images/logo250.png'),
                                  width: 150, // Kecilkan sedikit agar lebih proporsional
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'CRM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                // Gunakan Obx hanya pada Text-nya saja
                                Obx(() => Text(
                                      'v${controller.version.value}',
                                      style: TextStyle(
                                          color: ColorHelper.hint, fontSize: 12),
                                    )),
                                const SizedBox(height: 20),
                                CustomTextComponent(
                                  labelText: 'Username',
                                  hint: 'Your username',
                                  icon: const Icon(Icons.person_outline),
                                  controller: controller.userController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomTextComponent(
                                  labelText: 'Password',
                                  hint: 'Your password',
                                  isPassword: true,
                                  icon: const Icon(Icons.lock_outline),
                                  controller: controller.passController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}