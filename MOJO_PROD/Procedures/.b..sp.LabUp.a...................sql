USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLabUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLabUpdate]

	(
	@LabKey int,
	@CompanyKey int,
	@HasLab tinyint
	)

AS


if @HasLab = 0
BEGIN
	Delete tLabCompany Where LabKey = @LabKey and CompanyKey = @CompanyKey

END
ELSE
BEGIN
	if not exists(select 1 from tLabCompany Where LabKey = @LabKey and CompanyKey = @CompanyKey)
		Insert tLabCompany(LabKey, CompanyKey)Values(@LabKey, @CompanyKey)


END
GO
