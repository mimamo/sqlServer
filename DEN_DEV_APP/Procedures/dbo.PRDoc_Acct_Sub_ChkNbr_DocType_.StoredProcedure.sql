USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType_]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType_] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10) as
       Select * from PRDoc
           where Acct     =  @parm1
             and Sub      =  @parm2
             and ChkNbr   =  @parm3
             and DocType  IN  ('HC', 'CK', 'ZC')
           order by Acct    ,
                    Sub     ,
                    ChkNbr  ,
                    DocType
GO
