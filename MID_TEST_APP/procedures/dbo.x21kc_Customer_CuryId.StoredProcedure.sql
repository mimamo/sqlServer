USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Customer_CuryId]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_Customer_CuryId] @parm1 varchar (15), @parm2 varchar (15) as
select c.custid from customer c, customer x where
c.custid = @parm1 and x.custid = @parm2 and 
c.curyid <> x.curyid
GO
