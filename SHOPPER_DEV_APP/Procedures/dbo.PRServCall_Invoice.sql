USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRServCall_Invoice]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRServCall_Invoice] @parm1 varchar (10) as
        Select * from smServCall
                where ServiceCallId like @parm1
                  and cmbInvoiceType = 'T'
                  and ServiceCallCompleted = 0
                  and ServiceCallStatus = 'R'
        Order by ServiceCallId
GO
