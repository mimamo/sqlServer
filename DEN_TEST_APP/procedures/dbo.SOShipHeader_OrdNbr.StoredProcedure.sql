USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_OrdNbr]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SOShipHeader_OrdNbr] @parm1 varchar ( 15) as
    Select * from SOShipHeader where OrdNbr like @parm1
                  order by OrdNbr
GO
