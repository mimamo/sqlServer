USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_CHARGH]    Script Date: 12/21/2015 14:34:27 ******/
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
