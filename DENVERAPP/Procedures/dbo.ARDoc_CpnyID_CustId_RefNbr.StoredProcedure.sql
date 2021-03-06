USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyID_CustId_RefNbr]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyID_CustId_RefNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_CpnyID_CustId_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 10) as
    select * from ardoc where
    CpnyId like @parm1
    and custid = @parm2
    and refnbr like @parm3
    and doctype IN ('FI', 'IN', 'DM')
    and curydocbal > 0
    and Rlsed = 1
    order by CustId, Refnbr
GO
