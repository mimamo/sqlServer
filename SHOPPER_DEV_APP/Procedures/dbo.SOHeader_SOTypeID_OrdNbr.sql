USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_SOTypeID_OrdNbr]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SOHeader_SOTypeID_OrdNbr] @parm1 varchar ( 4), @parm2 varchar ( 15) as
    Select * from SOHeader where SOTypeID like @parm1

       and OrdNbr like @parm2
                  order by OrdNbr, SOTypeID
GO
