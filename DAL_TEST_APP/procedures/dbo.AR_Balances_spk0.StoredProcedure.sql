USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Balances_spk0]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[AR_Balances_spk0] @parm1 varchar (10), @parm2 varchar (15)   as
select * from AR_Balances
where
CpnyId = @parm1 and
CustId = @parm2
order by CpnyId, CustId
GO
