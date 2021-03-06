USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[PJTranView]    Script Date: 12/21/2015 14:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJTranView] AS

SELECT p.acct, p.alloc_flag, p.amount, p.BaseCuryId, p.batch_id, p.batch_type, p.bill_batch_id, 
       p.CpnyId, p.crtd_datetime, p.crtd_prog, p.crtd_user, p.CuryEffDate, p.CuryId, p.CuryMultDiv,
       p.CuryRate, p.CuryRateType, p.CuryTranamt, p.data1, p.detail_num, p.employee, p.fiscalno, 
       p.gl_acct, p.gl_subacct, p.lupd_datetime, p.lupd_prog, p.lupd_user, p.noteid, p.pjt_entity,
       p.post_date, p.project, p.system_cd, p.trans_date, p.tr_comment, p.tr_id01, p.tr_id02, 
       p.tr_id03, p.tr_id04, p.tr_id05, p.tr_id06, p.tr_id07, p.tr_id08, p.tr_id09, p.tr_id10, 
       p.tr_id23, p.tr_id24, p.tr_id25, p.tr_id26, p.tr_id27, p.tr_id28, p.tr_id29, p.tr_id30, 
       p.tr_id31, p.tr_id32, p.tr_status, p.unit_of_measure, p.units, p.user1, p.user2, p.user3,
       p.user4, p.vendor_num, p.voucher_line, p.voucher_num,
       crtd_datetimeEX = e.crtd_datetime, crtd_progEX = e.crtd_prog, crtd_userEX = e.crtd_user, 
       e.equip_id, e.invtid, e.lotsernbr, 
       lupd_datetimeEX = e.lupd_datetime, lupd_progEX = e.lupd_prog, lupd_userEX = e.lupd_user,
       e.siteid, e.tr_id11, e.tr_id12, e.tr_id13, e.tr_id14, e.tr_id15, e.tr_id16, e.tr_id17,
       e.tr_id18, e.tr_id19, e.tr_id20, e.tr_id21, e.tr_id22, e.tr_status2, e.tr_status3, e.whseloc,
       SrcID = CASE WHEN e.tr_id12 = ' ' THEN e.tr_id11 ELSE e.tr_id12 END,
       j.manager1 Manager1, j.manager2 Manager2
  FROM PJTran p JOIN PJTranEx e
                  ON p.batch_id = e.batch_id 
                  AND p.fiscalno = e.fiscalno
                  AND p.detail_num = e.detail_num
                  AND p.system_cd = e.system_cd
                JOIN PJProj j
                  ON p.Project = j.Project
GO
