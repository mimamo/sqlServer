USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_sAll]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_sAll] @Parm1 varchar (10)  as
Select * from PJEXPHDR
Where DocNbr Like @parm1
Order by DocNbr
GO
