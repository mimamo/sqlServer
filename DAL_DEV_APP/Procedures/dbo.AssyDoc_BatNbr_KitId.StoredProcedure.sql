USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AssyDoc_BatNbr_KitId]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AssyDoc_BatNbr_KitId    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.AssyDoc_BatNbr_KitId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[AssyDoc_BatNbr_KitId] @parm1 varchar ( 10), @parm2 varchar ( 30) as
    Select * from AssyDoc
                where BatNbr = @parm1
                and KitId like @parm2
                order by BatNbr, KitId
GO
