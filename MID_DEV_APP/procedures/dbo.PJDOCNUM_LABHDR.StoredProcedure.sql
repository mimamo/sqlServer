USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_LABHDR]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_LABHDR] As
Select    LastUsed_LABHDR
from     PJdocnum
where id = '13'
order by id
GO
