USE [DALLASAPP]
GO
/****** Object:  View [dbo].[pjdetana1]    Script Date: 12/21/2015 13:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[pjdetana1] as

select   

        pjtran.project Project,
        pjtran.pjt_entity Task,
        pjtran.fiscalno Period,
        pjtran.trans_date 'Date',
        pjtran.voucher_num DocNbr,
        'SrcAcct' = case when pjtranex.tr_id12 = '' 
                         then pjtran.acct
                         else pjtran.data1
                         end,
        pjtran.vendor_num Vendor,
        pjtran.employee Employee,
        pjtran.tr_id05 LaborClass,
        'SrcID' = case when pjtranex.tr_id12 = '' 
                       then pjtranex.tr_id11
                       else pjtranex.tr_id12
                       end,

        'Hours' = CAST(sum(case when pjacct.acct_type = 'EX' and pjacct.id5_sw = 'L' then 
                       round(pjtran.units,2)
                                else 0.00
                                 END) AS DEC(28,2)),
        'Revenue' = CAST(sum(case when pjacct.acct_type = 'RV' and pjacct.id5_sw <> 'A' then 
                         round(pjtran.amount,2)
                                else 0.00
                                END) AS DEC(28,2)),
        'RevAdj' = CAST(sum(case when pjacct.acct_type = 'RV' and pjacct.id5_sw = 'A' then 
                        round(pjtran.amount,2)
                                else 0.00
                                END) AS DEC(28,2)),
        'Labor' = CAST(sum(case when pjacct.acct_type = 'EX' and pjacct.id5_sw = 'L'  then 
                       round(pjtran.amount,2)
                                else 0.00
                                END) AS DEC(28,2)),

        'Expense' = CAST(sum(case when pjacct.acct_type = 'EX' and pjacct.id5_sw <> 'L' then 
                         round(pjtran.amount,2)
                                else 0.00
                                END) AS DEC(28,2))

from pjtran, pjtranex, pjacct
where    pjtran.fiscalno = pjtranex.fiscalno
   and    pjtran.system_cd = pjtranex.system_cd
   and    pjtran.batch_id = pjtranex.batch_id
   and    pjtran.detail_num = pjtranex.detail_num
   and    pjacct.acct = pjtran.acct
   and  pjacct.acct_type in ('RV','EX')
GROUP BY project, pjt_entity, pjtran.fiscalno, trans_date, voucher_num, 
case when pjtranex.tr_id12 = '' then
          pjtran.acct
          else pjtran.data1
          end, 
vendor_num, employee, tr_id05, 
case when pjtranex.tr_id12 = '' then
          pjtranex.tr_id11      
     else pjtranex.tr_id12
     end
GO
