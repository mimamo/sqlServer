USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_DRAFTINV]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_DRAFTINV] As
Select   LastUsed_2
from     PJdocnum
where id = '2'
Order by ID
GO
