USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_LABHDR]    Script Date: 12/21/2015 13:44:59 ******/
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
