USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_poaddress_DUP]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_poaddress_DUP] @parm1 varchar(15), @parm2 varchar (15) as
select * from poaddress p, poaddress x where
p.vendid = @parm1 and x.vendid = @parm2 and
p.ordfromid = x.ordfromid
GO
