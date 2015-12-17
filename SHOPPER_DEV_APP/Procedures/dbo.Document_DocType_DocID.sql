USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Document_DocType_DocID]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Document_DocType_DocID    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.Document_DocType_DocID    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc [dbo].[Document_DocType_DocID] @parm1 varchar ( 1), @parm2 varchar ( 40) as
       Select * from Document
           where DocType  LIKE  @parm1
             and DocID    LIKE  @parm2
           order by DocType,
                    DocID
GO
