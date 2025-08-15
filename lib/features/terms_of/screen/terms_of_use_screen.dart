// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:market_jango/core/widget/aboute_backgrount_image.dart';
import 'package:market_jango/core/widget/aboute_fooder.dart';
import 'package:market_jango/core/widget/custom_home_topper_section.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  static final routeName = "/TermsOfUseScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              AbouteBackgrountImage(screenName: "Terms of Use"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Oloflix Terms of Use",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildParagraph(
                      "Oloflix provides a personalized subscription service that allows our members to access entertainment and educative content over the Internet on certain mediums.",
                    ),
                    _buildParagraph(
                      "These Terms of Use govern your use of our service. As used in these Terms of Use, “our service” or “the service” means the personalized service provided by Oloflix for discovering and accessing our content, including all features and functionalities, recommendations and reviews, our websites, and mobile Apps, as well as all content and software associated with our service.",
                    ),

                    _buildSectionTitle("1. Membership"),
                    _buildParagraph(
                      "1.1. Your Oloflix membership will continue until terminated. To use the Oloflix service you must have Good Internet access and a Media ready device, and provide us with one or more Payment Methods. “Payment Method” means a current, valid, accepted method of payment, as may be updated from time to time, and which may include payment through your account with a third party. Unless you cancel your membership before your billing date, Our system will notify you with a reminder to renew you subscription.",
                    ),
                    _buildParagraph(
                      "1.2. We may offer a number of membership plans, including memberships that are tied to specifics contents like Pay-Per-View. Some membership plans may have differing conditions and limitations, which will be disclosed at your sign-up or in other communications made available to you. You can find specific details regarding your Oloflix membership by visiting the oloflix.com website and clicking on the “Account” link available at the top of the pages under your profile name.",
                    ),

                    _buildSectionTitle("2. Promotional Offers."),
                    _buildParagraph(
                      "We may from time to time offer special promotional offers on our plans or memberships. Offer eligibility is determined by Oloflix at its sole discretion and we reserve the right to revoke an Offer and put your account on hold in the event that we determine you are not eligible. Members with an existing subscription may not be eligible for certain introductory Offers. The eligibility requirements and other limitations and conditions will be disclosed when you sign-up for the Offer or in other communications made available to you.",
                    ),

                    _buildSectionTitle("3. Billing and Cancellation"),
                    _buildParagraph(
                      "3.1. Billing Cycle. The membership fee for the Oloflix service and any other charges you may incur in connection with your use of the service, such as taxes and possible transaction fees, will be charged to your Payment Method on the specific payment date indicated on the “Account” page. The length of your billing cycle will depend on the type of subscription that you choose when you signed-up for the service. In some cases your payment date may change, for example if your Payment Method has not successfully settled, when you change your subscription plan or if your paid membership began on a day not contained in a given month.",
                    ),
                    _buildParagraph(
                      "3.2. Payment Methods. To use the Oloflix service you must provide one or more Payment Methods. You authorize us to charge any Payment Method associated to your account in case your primary Payment Method is declined or no longer available to us for payment of your subscription fee. You remain responsible for any uncollected amounts. If a payment is not successfully settled, due to expiration, insufficient funds, or otherwise, and you do not cancel your account, we may suspend your access to the service until we have successfully charged a valid Payment Method.",
                    ),
                    _buildParagraph(
                      "3.3. Updating your Payment Methods. You can update your Payment Methods by going to the “Account” page.",
                    ),
                    _buildParagraph(
                      "3.4. Cancellation. You can cancel your Oloflix membership at any time, and you will continue to have access to the Oloflix service through the end of your billing period. To the extent permitted by the applicable law, payments are non-refundable and we do not provide refunds or credits for any partial membership periods or unused Oloflix content. To cancel, go to the “Account” page and follow the instructions for cancellation. If you cancel your membership, your account will automatically close at the end of your current billing period.",
                    ),
                    _buildParagraph(
                      "3.5. Changes to the Price and Subscription Plans. We may change our subscription plans and the price of our service from time to time; however, any price changes or changes to your subscription plans will apply no earlier than 30 days following notice to you. If you do not wish to accept the price change or change to your subscription plan, you can cancel your subscription before the change takes effect.",
                    ),

                    _buildSectionTitle("4. About Our Services"),
                    _buildParagraph(
                      "4.1. The quality of the display of the Oloflix content may vary from device to device, and may be affected by a variety of factors, such as your location, the bandwidth available through and/or speed of your Internet connection. Availability is subject to your Internet service and device capabilities. You are responsible for all Internet access charges. Please check with your Internet provider for information on possible Internet data usage charges. The time it takes to begin watching Oloflix content will vary based on a number of factors, including your location, available bandwidth at the time, the content you have selected and the configuration of your device.",
                    ),
                    _buildParagraph(
                      "4.2. Oloflix software is developed for, oloflix.com and may solely be used for authorized streaming and to access Oloflix content through good Internet and capable devices. This software may vary by device and medium, and functionalities and features may also differ between devices. You acknowledge that the use of the service may require third party software that is subject to third party licenses. You agree that you may automatically receive updated versions of the Oloflix software and related third-party software.",
                    ),

                    _buildSectionTitle("5. Passwords and Account Access."),
                    _buildParagraph(
                      "You are responsible for any activity that occurs through your Oloflix account. By allowing others to access the account (which includes access to information on viewing activity for the account), you agree that such individuals are acting on your behalf and that you are bound by any changes that they may make to the account, including but not to limited changes to the subscription plan. To help maintain control over the account and to prevent any unauthorized users from accessing the account, you should maintain control over the devices that are used to access the service and not reveal the password of the account to anyone. You agree to provide and maintain accurate information relating to your account, including a valid email address so we can send you account related notices. We can terminate your account or place your account on hold in order to protect you, from fraudulent activity.",
                    ),

                    _buildSectionTitle(
                      "6. Warranties and Limitations on Liability.",
                    ),
                    _buildParagraph(
                      "The Oloflix service is provided “as is” and without warranty or condition. In particular, our service may not be uninterrupted or error-free. You waive all special, indirect and consequential damages against us.",
                    ),

                    _buildSectionTitle("7. Class Action Waiver."),
                    _buildParagraph(
                      "Where permitted under the applicable law, unless both you and Oloflix agree otherwise, the court may not otherwise preside over any form of a representative or class proceeding.",
                    ),

                    // ... (previous code remains the same)
                    _buildSectionTitle("8. Miscellaneous"),
                    _buildParagraph(
                      "8.1. Governing Law. These Terms of Use shall be governed by and construed in accordance with the laws of the Federal Republic of Nigeria.",
                    ),
                    _buildParagraph(
                      "8.2. Customer Support. To find more information about our service and its features or if you need assistance with your account, please visit the “Contact Us” Page for our details. This is accessible through the oloflix.com website. In certain instances, Customer Service may best be able to assist you by using a remote access support tool through which we have full access to your computer. If you do not want us to have this access, you should not consent to support through the remote access tool, and we will assist you through other means. In the event of any conflict between these Terms of Use and information provided by Customer Support or other portions of our websites, these Terms of Use will control.",
                    ),
                    _buildParagraph(
                      "8.3. Electronic Communications. We will send you information relating to your account (e.g. payment authorizations, invoices, changes in password or Payment Method, confirmation messages, notices) in electronic form only, for example via emails to your email address provided during registration.",
                    ),

                    SizedBox(height: 24.h),
                    Text(
                      "Last Updated: September 27, 2025",
                      // You might want to update this date
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 10.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 15.sp, height: 1.5),
      ),
    );
  }
}
