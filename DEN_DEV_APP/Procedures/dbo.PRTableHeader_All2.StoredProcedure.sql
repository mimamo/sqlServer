USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableHeader_All2]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTableHeader_All2] @parm1 varchar ( 4), @parm2 varchar ( 4) as
       Select * from PRTableHeader
           where CalYr = @parm1
             and PayTblId like @parm2
           order by PayTblId
GO
