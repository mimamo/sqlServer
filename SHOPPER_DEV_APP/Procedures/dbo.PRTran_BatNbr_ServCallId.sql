USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_ServCallId]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_BatNbr_ServCallId] @parm1 varchar (10) as
       Select * from PRTran
               where BatNbr            = @parm1
                 and SS_PostFlag       = 'U'
                 and SS_ServiceCallID <> ''
           order by BatNbr,
                    SS_ServiceCallID
GO
