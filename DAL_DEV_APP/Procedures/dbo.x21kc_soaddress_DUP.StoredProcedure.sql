USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_soaddress_DUP]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_soaddress_DUP] @parm1 varchar(15), @parm2 varchar (15) as
select s.custid from soaddress s , soaddress x where
s.custid = @parm1 and x.custid = @parm2 and
s.shiptoid = x.shiptoid
GO
