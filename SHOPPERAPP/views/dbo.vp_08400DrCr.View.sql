USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_08400DrCr]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400DrCr] As
SELECT DrCr ='D'
UNION 
SELECT 'C'
GO
