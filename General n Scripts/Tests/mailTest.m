load mailTest.mat;
mailContent = strrep('enter/\key','/\',char(13));
SendGmailPPMS('omri_s@yahoo.com','Finished Measurements',mailContent);

