USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateCustomizations]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateCustomizations]
	@CompanyKey int,
	@Customizations varchar(1000)

AS

 /*
  || When     Who Rel    What
  || 04/17/13 MFT 10.567 Created
 */

UPDATE
	tPreference
SET
	Customizations = @Customizations
WHERE
	CompanyKey = @CompanyKey
GO
