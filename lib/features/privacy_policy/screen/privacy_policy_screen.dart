// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:Oloflix/core/widget/aboute_backgrount_image.dart';
import 'package:Oloflix/core/widget/aboute_fooder.dart';
import 'package:Oloflix/core/widget/custom_home_topper_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static final routeName = "/PrivacyPolicyScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHomeTopperSection(),
              AbouteBackgrountImage(screenName: "Privacy Policy"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Privacy Policy",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "We at Oloflix care about the privacy and protection of your personal data. We strive to be transparent in our data collection practices while providing you with a service that you love and trust.",
                      style: TextStyle(fontSize: 16.sp, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle(
                      "What Personal Data can Oloflix collect?",
                    ),
                    _buildParagraph(
                      "\"Personal Data\" is information that we collect that: may identify you as an individual; is reasonably associated with you; or is defined as such under applicable laws or regulations.",
                    ),
                    _buildParagraph("• Name"),
                    _buildParagraph("• Address"),
                    _buildParagraph("• Phone"),
                    _buildParagraph("• Email address"),
                    _buildParagraph("• Username"),
                    _buildParagraph("• Image"),
                    _buildParagraph("• Password"),
                    _buildParagraph(
                      "• IP Address (as permitted by applicable law)",
                    ),
                    _buildParagraph(
                      "• Any other personal data that you authorize us to collect or provide to us",
                    ),
                    _buildParagraph(
                      "NB: We \"Do Not\" collect Payment Information as this is handled externally by Paystack payment processor",
                    ),
                    SizedBox(height: 12.h),
                    _buildParagraph(
                      "We also collect other information that is not Personal Data but we may Link to Personal Data about you:",
                    ),
                    _buildParagraph(
                      "1. Usage Statistics (what, where, when, how you are using our Services)",
                    ),
                    _buildParagraph(
                      "2. Debugging Information (logs, metadata, or other information about your devices, media, and experiences for the purpose of resolving any issue you may have with the software or suggesting desired features)",
                    ),
                    _buildParagraph(
                      "3. Device Information (operating system, version of the device/browser used to access the services, versions of the Oloflix software being used)",
                    ),
                    _buildParagraph(
                      "4. Data that you allow us to collect through your interaction with us by using our contact form or sending email to our dedicated email accounts — admin@oloflix.com and support@oloflix.com",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle(
                      "When does Oloflix collects Personal Data:",
                    ),
                    _buildParagraph(
                      "1. When you create an account on Oloflix.com or Oloflix App, we collect Personal Data including: e-mail address, username, and password, name (if available), and image (if available).",
                    ),
                    _buildParagraph(
                      "2. When you wish to conduct a business transaction with us, we collect Personal Data including: name, email, address, phone number.",
                    ),
                    _buildParagraph(
                      "3. When you connect your Oloflix account to an external service (e.g., social networking site), we collect Personal Data including: name, email, public profile, other data you have authorized that service to provide.",
                    ),
                    _buildParagraph(
                      "4. When you apply for a job at Oloflix, we collect Personal Data including: Name, phone, email address, any other information that you include in your CV/resume.",
                    ),
                    _buildParagraph(
                      "5. When you use our Services, we collect Personal Data including: IP address (as permitted by applicable law), usage statistics (as permitted by applicable law), debugging information, device information.",
                    ),
                    _buildParagraph(
                      "6. When you contact us, we collect Personal Data including: Name, email, username, any other information that you include in your request.",
                    ),
                    _buildParagraph(
                      "Oloflix collects very limited Personal Data from users interacting with our services.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("Where does Oloflix store it?"),
                    _buildParagraph(
                      "All of Oloflix Solutions - website, scripts, database etc are hosted on our dedicated server provided by HostGator Inc, Houston — USA. As required for best practices and the design process, all collected data sits on our database and are available to be shared with authorized data processors. Collected user data including images are stored in each user table in our database, this comes encrypted during transit. Oloflix take adequate measures to ensure that Personal Data transferred internationally is protected in accordance with applicable laws, including by utilizing Standard Contractual Clauses and other applicable transfer mechanisms for data transfers to the data processors located in Nigeria and other countries.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("Why Oloflix collects it:"),
                    _buildParagraph("1. To provide the Services"),
                    _buildParagraph("2. To improve and enhance the Services"),
                    _buildParagraph("3. Product development"),
                    _buildParagraph("4. To respond to your requests"),
                    _buildParagraph(
                      "5. To consider your application for a job",
                    ),
                    _buildParagraph(
                      "6. To communicate with you about Oloflix (as permitted by applicable law)",
                    ),
                    _buildParagraph(
                      "7. To personalize marketing, advertising, recommendations, and other content and experiences delivered or offered to you through the Services (as permitted by applicable law)",
                    ),
                    _buildParagraph(
                      "8. To facilitate your payment for any products and services we sell",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("Who Oloflix shares it with:"),
                    _buildParagraph(
                      "Oloflix may share Personal Data as follows:",
                    ),
                    _buildParagraph(
                      "1. With third-party service providers that assist us in providing the Services. These include payment processors, business and analytics providers, content providers, marketers, and cloud service providers. All of these third parties are contractually required to only use your Personal Data for the specific purposes of providing the services requested of them.",
                    ),
                    _buildParagraph(
                      "2. If disclosure is reasonably necessary to (a) satisfy an applicable law, regulation, legal process, or valid governmental request; or (b) protect or defend the safety, rights, or property of Oloflix, the public, or any person.",
                    ),
                    _buildParagraph(
                      "3. In connection with a merger, acquisition, bankruptcy, dissolution, reorganization, or similar transaction or other proceeding involving Oloflix that includes or requires the transfer of the Personal Data.",
                    ),
                    _buildParagraph(
                      "4. If your Personal Data is either anonymized or made part of an aggregated set of information in which such data is no longer considered Personal Data (e.g., usage statistics and viewing trends).",
                    ),
                    _buildParagraph(
                      "5. With third parties to improve and deliver advertising to you on our behalf and on behalf of others, including with the use of hashed emails, as permitted by applicable law.",
                    ),
                    _buildParagraph(
                      "6. If you request or consent to our disclosing, or sharing of your Personal Data with a third party as required by law or as disclosed at the time of collection.",
                    ),
                    _buildParagraph(
                      "For Profile related use, images are collected. We do not share images with any 3rd party Except if there's request from authorities for user identification. Images are only uploaded for the purpose of account creation and it is not compulsory. It is Optional.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("How Oloflix protects it:"),
                    _buildParagraph(
                      "1. Oloflix Dedicated Hosting Plan: Oloflix provides publicly trusted TLS certificates for end-to-end encrypted connections to our hosting servers, Services, and client applications hosted with HostGator.",
                    ),
                    _buildParagraph(
                      "2. Your Personal Data: We have commercially reasonable physical, electronic, and organizational procedures to help safeguard and secure your Personal Data. We do not store any of your payment or credit card information on our servers. That data is stored by a third party that provides payment-processing services for Oloflix.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("How long does Oloflix keep my data?"),
                    _buildParagraph(
                      "Oloflix retains the Personal Data in your Oloflix account for as long as you maintain that account. Specifically, we delete data used for logging and error tracking after 90 days and we reset cookies on our website after 14 days. We also delete Personal Data in your Oloflix account within 30 days after your account is deleted. We may retain some usage statistics (including IP addresses) for as long as we have a business purpose in order to improve Oloflix's services, but these statistics are no longer linked to the Personal Data.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("Your Oloflix Privacy Rights:"),
                    _buildParagraph("Regardless of your global location,"),
                    _buildParagraph(
                      "1. Oloflix sends Notifications to account holders. You have the right to Switch Off these notifications. In your Account Settings, swipe the button next to \"Enable Puch Notifications\" This will turn it off. Also, all Oloflix promotional email comes with \"unsubscribe\" button beneath the mail. Click the \"unsubscribe\" link and follow the steps that follows. Please note that you cannot opt out from receiving all Oloflix communications, including administrative messages, service announcements, and messages regarding the terms and conditions of your account When your Oloflix account is still active.",
                    ),
                    _buildParagraph(
                      "2. You have the right to know the Personal Data that Oloflix has collected. After verifying your identity, Oloflix will provide you with a copy of Personal Data associated with your account. Click here to email our Data Protection team (please include details of what you are requesting in the body of the email).",
                    ),
                    _buildParagraph(
                      "3. You have the right to use the \"delete button\" available both on the website and App to delete your account. With a 2nd option to request Oloflix delete the Personal Data that it has collected. After verifying your identity, Oloflix will delete Personal Data associated with your account except that we may retain archived copies as required by law. Keep in mind that this option will result in the deletion of your Oloflix account permanently. Click here for account deletion request or visit here",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle(
                      "Does Oloflix collect information from children?",
                    ),
                    _buildParagraph(
                      "Oloflix does not knowingly collect, use, or disclose Personal Data from anyone under the age of 14. If we learn or are notified that we have collected the Personal Data of an individual under 14, we will take steps to delete that Personal Data as soon as possible. Oloflix user's parents or guardians can create managed user accounts for their children to restrict access to content based access.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("Use of Cookies"),
                    _buildParagraph(
                      "Cookies are piece of data from a website that is stored within a web browser that the website can retrieve at a later time. Cookies are used to tell the server that users have returned to a particular website. When users return to a website, a cookie provides information and allows the site to display selected settings and targeted content.",
                    ),
                    _buildParagraph(
                      "Cookies also store information such as shopping cart contents, registration or login credentials, and user preferences. This is done so that when users revisit sites, any information that was provided in a previous session or any set preferences can be easily retrieved.",
                    ),
                    _buildParagraph(
                      "Oloflix has cookies enabled as this help us to improve your browsing experience and provide personalized services on Oloflix website and App. We use these cookies to understand your interactions with contents on Oloflix thereby enabling us to recommend contents of interests to you. You have the Option to Accept or Reject these cookies.",
                    ),
                    SizedBox(height: 12.h),

                    _buildSectionTitle("CONTACTING US:"),
                    _buildParagraph(
                      "If you have questions about this Privacy Policy, please submit them on our contact page or email us.",
                    ),
                    _buildParagraph(
                      "This Privacy Policy may be updated from time to time. We will notify you of any changes by posting the new Privacy Policy on the Olofix.com website. If we make any material changes to the Personal Data that we collect and/or how we use it, we will first obtain your consent before applying any of those changes to your Personal Data collected before that change. You are advised to consult this Privacy Policy regularly for any changes.",
                    ),
                    _buildParagraph(
                      "Please note that if you contact us to assist you, for your safety and ours we may need to authenticate your identity before fulfilling your request.",
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      "Updated: August 20th, 2025",
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