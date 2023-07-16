import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

class BoxCustomPayment extends StatelessWidget {
  const BoxCustomPayment(
      {Key? key,
      required this.totalTagihan,
      required this.label,
      required this.isPaymentAccount,
      this.bankAccount = '',
      this.nameAccount = ''})
      : super(key: key);
  final num totalTagihan;
  final String label, bankAccount, nameAccount;
  final bool isPaymentAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins()),
        SizedBox(
          height: 10.h,
        ),
        isPaymentAccount == true
            ? Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10).r,
                child: Text('An. $nameAccount', style: GoogleFonts.poppins()))
            : const SizedBox(),
        Container(
          width: double.infinity,
          height: 45.h,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5).r,
          decoration: BoxDecoration(
              color: const Color(0xffC9EEFF),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isPaymentAccount == false
                    ? Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                            .format(totalTagihan),
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600))
                    : Text(bankAccount.toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600)),
                IconButton(
                    onPressed: () {
                      showToast('Berhasil Di Salin',
                          textStyle: GoogleFonts.poppins(),
                          position: const ToastPosition(
                              align: Alignment.bottomCenter));
                      isPaymentAccount == false
                          ? Clipboard.setData(
                              ClipboardData(text: totalTagihan.toString()))
                          : Clipboard.setData(
                              ClipboardData(text: bankAccount.toString()));
                    },
                    icon: const Icon(Icons.copy))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
