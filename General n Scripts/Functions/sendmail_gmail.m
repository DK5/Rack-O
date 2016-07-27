function SendGmail(LoginMail,Password,ToWhomMail,Subject,Content)

% Define these variables appropriately:
% LoginMail = Your GMail email address
% Password = Your GMail password
setpref('Internet','SMTP_Server','smtp.gmail.com');

setpref('Internet','E_mail',LoginMail);
setpref('Internet','SMTP_Username',LoginMail);
setpref('Internet','SMTP_Password',Password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email.  Note that the first input is the address you are sending the email to
% ToWhomMail = The email of the recipient
% Subject = email message subject
% Content = email message content
sendmail(ToWhomMail,Subject,Content)