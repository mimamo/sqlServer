USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_CHARGH]    Script Date: 12/21/2015 16:01:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_CHARGH] As
Select   LastUsed_CHARGH
from     PJdocnum
where id = '14'
order by id
GO
