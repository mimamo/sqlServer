USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMDoc_RefNbr_Status]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMDoc_RefNbr_Status] @parm1 varchar ( 15) as
    Select * from BOMDoc where Status <> 'V' and RefNbr like @parm1 order by RefNbr
GO
