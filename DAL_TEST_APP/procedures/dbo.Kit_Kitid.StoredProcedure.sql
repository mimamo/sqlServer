USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid] @parm1 varchar ( 30) as
            Select * from Kit where KitId like @parm1
                order by KitId
GO
