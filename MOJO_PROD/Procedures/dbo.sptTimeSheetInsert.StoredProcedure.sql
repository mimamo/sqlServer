USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetInsert]
	@CompanyKey int,
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Status smallint,
	@ApprovalComments varchar(300),
	@DateCreated smalldatetime,
	@DateSubmitted smalldatetime,
	@DateApproved smalldatetime
AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/17/09 MFT 10.507 Put key in return, removed identity param
  */

INSERT tTimeSheet
(
	CompanyKey,
	UserKey,
	StartDate,
	EndDate,
	Status,
	ApprovalComments,
	DateCreated,
	DateSubmitted,
	DateApproved
)
VALUES
(
	@CompanyKey,
	@UserKey,
	@StartDate,
	@EndDate,
	@Status,
	@ApprovalComments,
	@DateCreated,
	@DateSubmitted,
	@DateApproved
)
 
RETURN SCOPE_IDENTITY()
GO
