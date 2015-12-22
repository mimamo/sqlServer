/**************
NEW
***************/
 USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_send_cdosysmail]    Script Date: 06/22/2012 14:46:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER PROCEDURE [dbo].[sp_send_cdosysmail] 
	   @From varchar(100) ,
	   @To varchar(100) ,
	   @Subject varchar(100)=" ",
	   @Body varchar(4000) =" "
	/*********************************************************************
	
	This stored procedure takes the parameters and sends an e-mail. 
	All the mail configurations are hard-coded in the stored procedure. 
	Comments are added to the stored procedure where necessary.
	References to the CDOSYS objects are at the following MSDN Web site:
	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_messaging.asp
	
	***********************************************************************/ 
	   AS
	   Declare @iMsg int
	   Declare @hr int
	   Declare @source varchar(255)
	   Declare @description varchar(500)
	   Declare @output varchar(1000)
	   
------ BEGIN SCRIPT CONFIGURATION ------
	declare @strUser varchar
	declare @strPWD varchar
	declare @strSMTP varchar
	declare @intPort varchar
	declare @intSendMode varchar
	declare @intSMTPAuth varchar
	declare @boolUseSSL varchar

    set @strUser = 'dbert00'
    set @strPWD  = 'db061500' -- it was secure until i wrote it in a script
    set @strSMTP = 'smtp.gmail.com'  
    set @intPort = '465' -- this info from gmail, POP setups for other programs
    set @intSendMode = '2' -- use port to launch send, not a local dir or Exchange svr.
    set @intSMTPAuth = '1' -- use basic authentication

------ END SCRIPT CONFIGURATION --------
	
--***** Create the CDO.Message Object ***** 
 
 EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT 
 
 --*****Configuring the Message Object ***** 
 
 -- This is to configure a remote SMTP server.
 -- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_schema_configuration_sendusing.asp 
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields ("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2' 
 
 -- This is to configure the Server Name or IP address. 
 
 /*----------------------------------------------------
    'Name or IP of Remote SMTP Server
    '----------------------------------------------------*/
 -- Replace MailServerName by the name or IP of your SMTP Server.
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas. microsoft.com/cdo/configuration/smtpserver").Value', @strSMTP 

    /*----------------------------------------------------
    'Type of authentication, NONE, Basic (Base64 encoded), NTLM
    '----------------------------------------------------*/
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").Value', '1'

    /*----------------------------------------------------
    'Your UserID on the SMTP server
    '----------------------------------------------------*/
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusername").Value', @strUser

    /*----------------------------------------------------
    'Your password on the SMTP server
    '----------------------------------------------------*/
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendpassword").Value', @strPWD

    /*----------------------------------------------------
    'Server port (typically 25)
    '----------------------------------------------------*/
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport").Value', '465'

    /*----------------------------------------------------
    'Use SSL for authentication (BOOL)
    '----------------------------------------------------*/
 EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpusessl").Value', '1'
 
 	/*----------------------------------------------------
    'Use set timeout for the smtp server
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout").Value', '60'

 
 -- Save the configurations to the message object.
 EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null
 
 -- Set the e-mail parameters.
 EXEC @hr = sp_OASetProperty @iMsg, 'To', @To
 EXEC @hr = sp_OASetProperty @iMsg, 'From', @From
 EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject
 
 -- If you are using HTML e-mail, use 'HTMLBody' instead of 'TextBody'.
 EXEC @hr = sp_OASetProperty @iMsg, 'HTMLBody', @Body
-- EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL
 
 EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OAMethod Send')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OAMethod Send')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
 
 -- Do some error handling after each step if you have to.
	-- Clean up the objects created.
        send_cdosysmail_cleanup:
	If (@iMsg IS NOT NULL) -- if @iMsg is NOT NULL then destroy it
	BEGIN
		EXEC @hr=sp_OADestroy @iMsg
	
		-- handle the failure of the destroy if needed
		IF @hr <>0 
	     	BEGIN
			select @hr
        	        INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OADestroy')
	       		EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	
			-- if sp_OAGetErrorInfo was successful, print errors
			IF @hr = 0
			BEGIN
				SELECT @output = '  Source: ' + @source
			        PRINT  @output
			        SELECT @output = '  Description: ' + @description
			        PRINT  @output
				INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OADestroy')
			END
			
			-- else sp_OAGetErrorInfo failed
			ELSE
			BEGIN
				PRINT '  sp_OAGetErrorInfo failed.'
			        RETURN
			END
		END
	END
	ELSE 
	BEGIN
		PRINT ' sp_OADestroy skipped because @iMsg is NULL.'
		INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, '@iMsg is NULL, sp_OADestroy skipped')
	        RETURN
	END
 
 
 
 
 
 /*****************************************************************
 OLD STORED PROCEDURE
 ******************************************************************/
 	USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[sp_send_cdosysmail]    Script Date: 06/22/2012 14:46:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	ALTER PROCEDURE [dbo].[sp_send_cdosysmail] 
	   @From varchar(100) ,
	   @To varchar(100) ,
	   @Subject varchar(100)=" ",
	   @Body varchar(4000) =" "
	/*********************************************************************
	
	This stored procedure takes the parameters and sends an e-mail. 
	All the mail configurations are hard-coded in the stored procedure. 
	Comments are added to the stored procedure where necessary.
	References to the CDOSYS objects are at the following MSDN Web site:
	http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_messaging.asp
	
	***********************************************************************/ 
	   AS
	   Declare @iMsg int
	   Declare @hr int
	   Declare @source varchar(255)
	   Declare @description varchar(500)
	   Declare @output varchar(1000)
	   
------ BEGIN SCRIPT CONFIGURATION ------
	declare @strUser varchar
	declare @strPWD varchar
	declare @strSMTP varchar
	declare @intPort varchar
	declare @intSendMode varchar
	declare @intSMTPAuth varchar
	declare @boolUseSSL varchar

    set @strUser = 'dbert00'
    set @strPWD  = 'db061500' -- it was secure until i wrote it in a script
    set @strSMTP = 'smtp.gmail.com'  
    set @intPort = '465' -- this info from gmail, POP setups for other programs
    set @intSendMode = '2' -- use port to launch send, not a local dir or Exchange svr.
    set @intSMTPAuth = '1' -- use basic authentication

------ END SCRIPT CONFIGURATION --------
	
--************* Create the CDO.Message Object ************************
	   EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OACreate')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
                   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OACreate')
                   RETURN
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           RETURN
	         END
	     END
	
	--***************Configuring the Message Object ******************
	-- This is to configure a remote SMTP server.
	-- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/_cdosys_schema_configuration_sendusing.asp
	/*----------------------------------------------------
    'This section provides the configuration information for the remote SMTP server.
    'Normally you will only change the server name or IP.
    '----------------------------------------------------*/
	   EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value', '2'
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty sendusing')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
                   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty sendusing')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
	     
	/*----------------------------------------------------
    'Name or IP of Remote SMTP Server
    '----------------------------------------------------*/
-- This is to configure the Server Name or IP address. 
	-- Replace MailServerName by the name or IP of your SMTP Server.
	   EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', @strSMTP 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

    /*----------------------------------------------------
    'Type of authentication, NONE, Basic (Base64 encoded), NTLM
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").Value', '1' 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

    /*----------------------------------------------------
    'Your UserID on the SMTP server
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusername").Value', @strUser 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

    /*----------------------------------------------------
    'Your password on the SMTP server
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendpassword").Value', @strPWD 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

    /*----------------------------------------------------
    'Server port (typically 25)
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport").Value', '465' 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

    /*----------------------------------------------------
    'Use SSL for authentication (BOOL)
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpusessl").Value', '1' 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
	     
	/*----------------------------------------------------
    'Use set timeout for the smtp server
    '----------------------------------------------------*/
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout").Value', '60' 
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty smtpserver')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty smtpserver')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END


	-- Save the configurations to the message object.
	   EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty Update')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty Update')                 
		   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
	
	-- Set the e-mail parameters.
	   EXEC @hr = sp_OASetProperty @iMsg, 'To', @To
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty To')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty To')                 
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

	   EXEC @hr = sp_OASetProperty @iMsg, 'From', @From
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty From')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty From')                 
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

	   EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty Subject')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty Subject')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
	
	-- If you are using HTML e-mail, use 'HTMLBody' instead of 'TextBody'.
	   EXEC @hr = sp_OASetProperty @iMsg, 'HTMLBody', @Body
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OASetProperty HTMLBody')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OASetProperty HTMLBody')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END

	   EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL
	   IF @hr <>0 
	     BEGIN
	       SELECT @hr
	       INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OAMethod Send')
	       EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	       IF @hr = 0
	         BEGIN
	           SELECT @output = '  Source: ' + @source
	           PRINT  @output
	           SELECT @output = '  Description: ' + @description
	           PRINT  @output
  	  	   INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OAMethod Send')
                   GOTO send_cdosysmail_cleanup
	         END
	       ELSE
	         BEGIN
	           PRINT '  sp_OAGetErrorInfo failed.'
	           GOTO send_cdosysmail_cleanup
	         END
	     END
	     
	     -- Do some error handling after each step if you have to.
	-- Clean up the objects created.
        send_cdosysmail_cleanup:
	If (@iMsg IS NOT NULL) -- if @iMsg is NOT NULL then destroy it
	BEGIN
		EXEC @hr=sp_OADestroy @iMsg
	
		-- handle the failure of the destroy if needed
		IF @hr <>0 
	     	BEGIN
			select @hr
        	        INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'Failed at sp_OADestroy')
	       		EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
	
			-- if sp_OAGetErrorInfo was successful, print errors
			IF @hr = 0
			BEGIN
				SELECT @output = '  Source: ' + @source
			        PRINT  @output
			        SELECT @output = '  Description: ' + @description
			        PRINT  @output
				INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, 'sp_OAGetErrorInfo for sp_OADestroy')
			END
			
			-- else sp_OAGetErrorInfo failed
			ELSE
			BEGIN
				PRINT '  sp_OAGetErrorInfo failed.'
			        RETURN
			END
		END
	END
	ELSE 
	BEGIN
		PRINT ' sp_OADestroy skipped because @iMsg is NULL.'
		INSERT INTO [dbo].[cdosysmail_failures] VALUES (getdate(), @@spid, @From, @To, @Subject, @Body, @iMsg, @hr, @source, @description, @output, '@iMsg is NULL, sp_OADestroy skipped')
	        RETURN
	END