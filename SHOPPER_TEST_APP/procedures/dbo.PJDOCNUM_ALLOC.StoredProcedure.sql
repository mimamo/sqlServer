USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_ALLOC]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_ALLOC] As
Select  *
from     PJdocnum
where id = '15'
order by id
GO
