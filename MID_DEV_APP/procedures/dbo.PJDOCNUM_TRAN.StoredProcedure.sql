USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_TRAN]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_TRAN] As
Select  *
from     PJdocnum
where id = '16'
order by id
GO
