USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_sAll]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_sAll] @Parm1 varchar (10)  as
Select * from PJEXPHDR
Where DocNbr Like @parm1
Order by DocNbr
GO
