USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType4]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRDoc_Acct_Sub_ChkNbr_DocType4] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10), @parm4 varchar (10) as
       Select * from PRDoc
           where Acct     =  @parm1
             and Sub      =  @parm2
             and CpnyId LIKE @parm3
             and ChkNbr = @parm4
             and DocType  IN  ('HC', 'CK', 'ZC')
             and Status<>'C'
     	     and chknbr not in (select chknbr from prdoc where doctype = 'VC')
           order by Acct    ,
                    Sub     ,
                    ChkNbr  ,
                    DocType
GO
