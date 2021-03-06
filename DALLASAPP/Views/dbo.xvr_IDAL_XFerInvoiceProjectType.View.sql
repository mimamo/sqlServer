USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_IDAL_XFerInvoiceProjectType]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_IDAL_XFerInvoiceProjectType]
AS
SELECT DISTINCT
	batch_id, 
	RIGHT(RTRIM(Project), 2) as ProjectType
FROM
	PJTRAN
WHERE
	crtd_prog = 'BITFR' AND
	RIGHT(RTRIM(Project), 2) <> 'AG'
GO
