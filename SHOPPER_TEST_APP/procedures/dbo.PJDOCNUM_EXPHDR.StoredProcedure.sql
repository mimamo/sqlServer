USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_EXPHDR]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_EXPHDR] As
Select   LastUsed_5
from     PJdocnum
where id = '5'
order by id
GO
