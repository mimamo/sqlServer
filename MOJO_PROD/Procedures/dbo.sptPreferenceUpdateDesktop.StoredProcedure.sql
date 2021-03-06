USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateDesktop]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateDesktop]
	(
		@CompanyKey int,
		@DesktopColor1 int,
		@DesktopColor2 int,
		@DesktopWindowColor int,
		@DesktopImage varchar(300),
		@DesktopImageIndex int,
		@DesktopImageSetting varchar(30),
		@DesktopImageScale int,
		@DesktopLogoPosition int,
		@SmallLogo varchar(50)
	)

AS

/*
|| When      Who Rel	    What
|| 06/09/08  QMD 10.0.0.2   (28227) Added @SmallLogo -- Gil: Please do NOT end by GO CRLF
*/

Update tPreference
Set
	DesktopColor1 = @DesktopColor1,
	DesktopColor2 = @DesktopColor2,
	DesktopWindowColor = @DesktopWindowColor,
	DesktopImage = @DesktopImage,
	DesktopImageIndex = @DesktopImageIndex,
	DesktopImageSetting = @DesktopImageSetting,
	DesktopImageScale = @DesktopImageScale,
	DesktopLogoPosition = @DesktopLogoPosition,
	SmallLogo = @SmallLogo -- Gil: Please do NOT end by GO CRLF
Where CompanyKey = @CompanyKey
GO
