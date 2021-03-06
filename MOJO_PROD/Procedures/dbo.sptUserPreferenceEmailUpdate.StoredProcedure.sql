USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceEmailUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptUserPreferenceEmailUpdate]
	@UserKey int,
	@EmailMailBox varchar(50),
	@EmailUserID varchar(50),
	@EmailPassword varchar(100)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 10/28/11 QMD 10.5.4.9  Increased size of emailpassword parm to match table def.
  || 05/24/12 QMD 10.5.5.6  Added update of EmailAttempts and EmailLastSent
  */

if exists(select 1 from tUserPreference (nolock) where UserKey = @UserKey)
	update
		tUserPreference
	set
		EmailMailBox = @EmailMailBox,
		EmailUserID = @EmailUserID,
		EmailPassword = @EmailPassword,
		EmailAttempts = 0,
		EmailLastSent = NULL		
	where
		UserKey = @UserKey 
else
	insert tUserPreference
		(
		UserKey,
		EmailMailBox,
		EmailUserID,
		EmailPassword
		)

	values
		(
		@UserKey,
		@EmailMailBox,
		@EmailUserID,
		@EmailPassword
		)
GO
