USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateFlagLogos]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateFlagLogos]

	(
		@InvoiceTemplateKey int,
		@CustomLogo tinyint
	)

AS -- ENCRYPT

/*
|| When     Who Rel     What
|| 01/23/07 BSH 8.41    Added defaults for Logo Height and Width if <= 0.
|| 01/31/07 RTC 8.4.0.3 changed sp name to prevent errors in update manager parsing
*/

DECLARE @LogoHeight as decimal(9, 3)
DECLARE @LogoWidth decimal(9, 3)

Select @LogoHeight = ISNULL(LogoHeight,0), @LogoWidth = ISNULL(LogoWidth, 0)
from tInvoiceTemplate
Where InvoiceTemplateKey = @InvoiceTemplateKey

--Default values only for insert of CustomLogo, not on remove. 
IF @CustomLogo = 1
BEGIN
	IF @LogoHeight <= 0
		SELECT @LogoHeight = 1
		
	IF @LogoWidth <= 0
		SELECT @LogoWidth = 1
END

Update tInvoiceTemplate
Set
	CustomLogo = @CustomLogo,
	LogoHeight = @LogoHeight,
	LogoWidth  = @LogoWidth
Where
	InvoiceTemplateKey = @InvoiceTemplateKey

RETURN 1
GO
