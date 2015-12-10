USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefInsert]
	@CompanyKey int,
	@UserKey int,
	@RequestName varchar(200),
	@FieldSetKey int,
	@RequestPrefix varchar(20),
	@ProjectDescription text,
	@Description varchar(500),
	@NextRequestNum int,
	@DisplayProjectFields tinyint,
	@RequireProjectName tinyint,
	@RequesterToProjectTeam tinyint,
	@Active tinyint,
	@MinDays smallint,
	@DisplayCampaign tinyint,
	@SendConfirmation tinyint,
	@ConfirmationMessage varchar(500),
	@PrintSpecOnSepPages tinyint,
	@TemplateProjectNumber varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

 /*
  || When     Who Rel       What
  || 11/10/10 RLB 10.5.3.8  (91299) Fields added for enhancement
  || 1/21/10 RLB 10.5.4.0   (99967) Fields added for enhancement
  || 12/19/11 CRG 10.5.5.1  (128766) Added MinDays
  || 05/29/12 QMD 10.5.5.6  (143615) Added DisplayCampaign
  || 07/17/12 MFT 10.5.5.8  (105753) Added SendConfirmation & ConfirmationMessage
  || 08/27/12 KMC 10.5.5.9  (151486) Added PrintSpecOnSeparatePages option
  || 10/29/12 KMC 10.5.6.1  (157441) Added TemplateProjectNumber option
  || 03/25/15 WDF 10.5.9.0  (250961) Added @UserKey, CreatedByKey, CreatedByDate, UpdatedByKey
 */

	INSERT tRequestDef
		(
		CompanyKey,
		RequestName,
		FieldSetKey,
		RequestPrefix,
		Description,
		NextRequestNum,
		ProjectDescription,
		DisplayProjectFields,
		RequireProjectName,
		RequesterToProjectTeam,
		Active,
		MinDays,
		DisplayCampaign,
		SendConfirmation,
		ConfirmationMessage,
		PrintSpecOnSeparatePages,
		TemplateProjectNumber,
		CreatedByKey,
		CreatedByDate,
		UpdatedByKey
		)

	VALUES
		(
		@CompanyKey,
		@RequestName,
		@FieldSetKey,
		@RequestPrefix,
		@Description,
		@NextRequestNum,
		@ProjectDescription,
		@DisplayProjectFields,
		@RequireProjectName,
		@RequesterToProjectTeam,
		@Active,
		@MinDays,
		@DisplayCampaign,
		@SendConfirmation,
		@ConfirmationMessage,
		@PrintSpecOnSepPages,
		@TemplateProjectNumber,
		@UserKey,
		GETUTCDATE(),
		@UserKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
