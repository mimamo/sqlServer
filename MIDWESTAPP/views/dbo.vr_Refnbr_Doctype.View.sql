USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vr_Refnbr_Doctype]    Script Date: 12/21/2015 15:55:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_Refnbr_Doctype] as
select refnbrtype=rtrim(refnbr) + '-' + rtrim(doctype), *
from ardoc
GO
