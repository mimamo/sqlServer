USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_sDocNbr]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_sDocNbr] @Parm1 varchar (10)  as
Select * from PJEXPHDR
Where DocNbr = @parm1
Order by DocNbr
GO
