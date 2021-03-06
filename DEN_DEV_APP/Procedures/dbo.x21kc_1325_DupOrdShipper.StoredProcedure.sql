USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_DupOrdShipper]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc  [dbo].[x21kc_1325_DupOrdShipper]  @fromcpnyid varchar(10), @tocpnyid varchar(10)as
select 'Duplicate Ordnbr:    ',  s1.ordnbr , s2.cpnyid from soheader s1, soheader s2 where
s1.cpnyid = @fromcpnyid
and S2.cpnyid = @tocpnyid
and s1.ordnbr = s2.ordnbr
union
select  'Duplicate ShipperId: ',s1.shipperid, s2.cpnyid from soshipheader s1, soshipheader s2 where
s1.cpnyid = @fromcpnyid
and S2.cpnyid = @tocpnyid
and s1.shipperid = s2.shipperid
GO
