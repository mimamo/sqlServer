USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableHeader_All]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTableHeader_All] @parm1 varchar ( 4) as
       Select * from PRTableHeader
           where PayTblId like @parm1
           order by PayTblId
GO
