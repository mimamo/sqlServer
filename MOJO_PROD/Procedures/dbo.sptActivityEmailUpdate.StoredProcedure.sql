USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityEmailUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityEmailUpdate]
	@ActivityKey int,
	@UserKey int,
	@UserLeadKey int,
	@Action varchar(15),
	@OriginalUser tinyint = 1
AS

/*
|| When      Who Rel      What
|| 06/02/09  RTC 10.5.0.0 Added User Leads to email list
|| 10/23/12  RLB 10.5.6.1 Added option parm to set OriginalUser 
*/

if @Action = 'insert' 
	if isnull(@UserKey, 0) > 0
		begin
			if not exists(select 1 from tActivityEmail (nolock) where ActivityKey = @ActivityKey and UserKey = @UserKey)
				insert tActivityEmail
				(
				ActivityKey,
				UserKey,
				OriginalUser
				)
				values
				(
				@ActivityKey,
				@UserKey,
				@OriginalUser
				)
		end
	else
		begin
			if not exists(select 1 from tActivityEmail (nolock) where ActivityKey = @ActivityKey and UserLeadKey = @UserLeadKey)
				insert tActivityEmail
				(
				ActivityKey,
				UserLeadKey
				)
				values
				(
				@ActivityKey,
				@UserLeadKey
				)		
		end
else
	--delete
	if isnull(@UserKey, 0) > 0
		delete tActivityEmail
		where ActivityKey = @ActivityKey 
		and UserKey = @UserKey
	else
		delete tActivityEmail
		where ActivityKey = @ActivityKey 
		and UserLeadKey = @UserLeadKey
GO
