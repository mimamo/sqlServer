USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableHeader_Paytblid_CalYr]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTableHeader_Paytblid_CalYr] @parm1 varchar ( 4), @parm2 varchar( 4) as
       Select * from PRTableHeader
           where PayTblId       like  @parm1
             and CalYr like @parm2
           order by PayTblId, CalYr
GO
