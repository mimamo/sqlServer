USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_OrdNbr_CpnyID]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SOShipHeader_OrdNbr_CpnyID] @parm1 varchar ( 15) , @parm2 varchar(10) as
    Select * from SOShipHeader where CpnyID like @parm2 and OrdNbr like @parm1
                  order by OrdNbr
GO
