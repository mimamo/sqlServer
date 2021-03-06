USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_24630]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[pp_24630] @RI_ID smallint
with execute as '07718158D19D4f5f9D23B55DBF5DF1'
as

declare @ri_where as varchar(255),
	@sri_id as varchar(6)

select @sri_id = convert(varchar(6),@ri_id)
select @ri_where = replace(coalesce((select ri_where from rptruntime where ri_id = @ri_id),""), "wrkcmugl.","v.")
if @ri_where <>""
	select @ri_where = " and ("+@ri_where+")"

exec(
"insert wrkcmugl (ri_id,cpnyid, curyid, doctype, refnbr, custid, vendid, docstatus, origrate, origmultdiv,
curypmtamt, origbasepmtamt, calcrate, calcmultdiv, calcbasepmtamt,
unrlgain, unrlloss, ugolacct, ugolsub)
select v.ri_id, v.cpnyid, v.curyid, v.doctype, v.refnbr, v.custid, v.vendid, v.docstatus, v.origrate, v.origmultdiv,
v.curypmtamt, v.origbasepmtamt, v.calcrate, v.calcmultdiv, v.calcbasepmtamt,
v.unrlgain, v.unrlloss, v.ugolacct, v.ugolsub
from vp_24630Wrk v
where v.ri_id = " + @sri_id + @ri_where + "
order by v.DocType, v.RefNbr")
GO
