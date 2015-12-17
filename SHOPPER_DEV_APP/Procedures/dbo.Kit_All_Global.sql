USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_All_Global]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Kit_All_Global    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Kit_All_Global    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Kit_All_Global] @parm1 varchar ( 30) as
            Select * from Kit where KitId like @parm1
                and SiteId = 'GLOBAL'
                and Status = 'A'
                order by KitId
GO
